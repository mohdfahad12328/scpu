extern crate pest;
#[macro_use]
extern crate pest_derive;

use std::{
    collections::HashMap,
    env,
    fs::{self, File},
    io::Write,
};

use pest::{
    iterators::{Pair, Pairs},
    Parser,
};

#[derive(Parser)]
#[grammar = "grammar.pest"]
struct PestParser;

struct Generator {
    defines_map: HashMap<String, String>,
    globals_table: HashMap<String, String>,
    vars_table: HashMap<String, String>,
    cur_func_name: String,
    func_output_code: Vec<String>,
    output_data: String,
    regs_used: [bool; 8],
    output_code: String,
}

const DEFAULT_B: &str = "0x00";
const DEFAULT_DB: &str = "0x0000";

impl Generator {
    fn new() -> Self {
        Generator {
            defines_map: HashMap::new(),
            globals_table: HashMap::new(),
            vars_table: HashMap::new(),
            cur_func_name: String::new(),
            func_output_code: Vec::new(),
            output_data: String::new(),
            output_code: String::new(),
            regs_used: [false, false, false, false, false, false, false, false],
        }
    }

    fn write_to_file(&self, file_name: &str) {
        println!("{}\n{}\n", self.output_code, self.output_data);
    }

    fn get_next_free_reg(&mut self) -> u8 {
        for i in 0..self.regs_used.len() {
            if self.regs_used[i] == false {
                self.regs_used[i] = true;
                return i as u8;
            }
        }
        self.regs_used.fill(true);
        return 0;
    }

    fn done_func(&mut self) {
        // data
        for t in &self.vars_table {
            let var_name = t.0;
            let value = t.1.replace("x", "h");
            self.output_data.push_str(
                format!("{}${}\n\t.b {}\n", self.cur_func_name, var_name, value).as_str(),
            );
        }
        // code
        for t in &self.func_output_code {
            self.output_code.push_str(t.as_str());
        }
    }
}

fn print_to_temp_file(data: &Pairs<Rule>) {
    let mut temp_file = File::create("temp.txt").unwrap();
    temp_file
        .write_all(format!("{:#?}", data).as_bytes())
        .unwrap();
}

fn parse_program(prg: Pairs<Rule>, gen: &mut Generator) {
    for stmts_or_func in prg.into_iter() {
        match stmts_or_func.as_rule() {
            Rule::stmt => {
                for stmt in stmts_or_func.into_inner() {
                    match stmt.as_rule() {
                        Rule::defineStmt => parse_define_stmt(stmt, gen),
                        Rule::createExpr => parse_global_expr(stmt, gen),
                        _ => {}
                    }
                }
            }
            Rule::func => parse_func(stmts_or_func, gen),
            _ => {}
        }
    }
    gen.write_to_file("out.asm");
}

fn parse_define_stmt(stmt: Pair<Rule>, gen: &mut Generator) {
    let mut stmt = stmt.into_inner();
    let ident = stmt.next().unwrap().as_str();
    let value = stmt.next().unwrap().as_str();
    gen.defines_map.insert(ident.to_string(), value.to_string());
}

fn parse_global_expr(expr: Pair<Rule>, gen: &mut Generator) {
    let expr: Vec<Pair<Rule>> = expr.into_inner().into_iter().collect();
    let ident = expr[0].as_str();
    if expr.len() == 2 {
        let value = expr[1].as_str();
        gen.globals_table
            .insert(ident.to_string(), value.to_string());
    } else {
        gen.globals_table
            .insert(ident.to_string(), DEFAULT_B.to_string());
    }
}

/*
 * let a = 1;
 * fn main() {
 *   let a = 2;
 *   a = 0;
 *   temp();
 * }
 * fn temp() {
 *   let a = 3;
 *   a = 6;
 * }
 * lets only push the status word register
 * here we need to add idents to a table for
 * result asm
 * .main
 *      ldr r0 0
 *      str r0 main$a
 *      call temp
 *  .temp
 *      ldr
 * .global$a
 *      .b 1
 * .main$a
 *      .b 2
 * .temp$a
 *      .b 3
 */
fn parse_local_expr(expr: Pair<Rule>, gen: &mut Generator) {
    let mut expr = expr.into_inner();
    let expr = expr.next().unwrap();
    let expr_rule = expr.as_rule();
    match expr_rule {
        Rule::assignExpr => parse_assign_expr(expr, gen),
        Rule::createExpr => parse_create_expr(expr, gen),
        _ => {}
    }
}

fn parse_assign_expr(expr: Pair<Rule>, gen: &mut Generator) {
    let expr: Vec<Pair<Rule>> = expr.into_inner().into_iter().collect();

    let mut code = String::new();
    let reg_indx = gen.get_next_free_reg();
    let lhs = expr[0].as_str();
    let rhs = expr[1].as_str();
    // assign ident to ident
    if expr[0].as_rule() == Rule::ident && expr[1].as_rule() == Rule::ident {
        code.push_str(format!("ldr r{} {}${}\n", reg_indx, gen.cur_func_name, rhs).as_str());
        code.push_str(format!("str r{} {}${}\n", reg_indx, gen.cur_func_name, lhs).as_str());
    }

    gen.func_output_code.push(code);
}

fn parse_create_expr(expr: Pair<Rule>, gen: &mut Generator) {
    let expr: Vec<Pair<Rule>> = expr.into_inner().into_iter().collect();
    let ident = expr[0].as_str();
    if expr.len() == 2 {
        let value = expr[1].as_str();
        gen.vars_table.insert(ident.to_string(), value.to_string());
    } else {
        gen.vars_table
            .insert(ident.to_string(), DEFAULT_B.to_string());
    }
}

fn parse_func(func: Pair<Rule>, gen: &mut Generator) {
    let mut func = func.into_inner();
    let func_ident = func.next().unwrap().as_str();

    gen.cur_func_name = func_ident.to_string();
    gen.func_output_code.push(format!("{}:\n", func_ident));

    let exprs: Vec<Pair<Rule>> = func.collect();

    assert_ne!(
        exprs[0].as_rule(),
        Rule::ident,
        "TODO: implement args in parse_func"
    );

    for expr in exprs {
        parse_local_expr(expr, gen);
    }

    gen.done_func();
}

fn main() {
    let args: Vec<String> = env::args().collect();

    let file_contents = fs::read_to_string(args[1].as_str()).expect("couldn't open the file");
    let program =
        PestParser::parse(Rule::program, &file_contents).expect("couldn't parse the file");

    // print to temp file
    print_to_temp_file(&program);

    let mut generator = Generator::new();

    parse_program(program, &mut generator);
}
