#include <bitset>
#include <cmath>
#include <fstream>
#include <iostream>
#include <ostream>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <assert.h>

using namespace std;

enum ErrType { parse };
enum Mode { imm, rda, rr, rria };
enum ParseStage { labels, insts };

class App {
  string inputFile;
  string outputFile;
  vector<string> tokens;
  unordered_map<string_view, string_view> onlyRegs;
  unordered_map<string_view, string_view> onlyAddr;
  unordered_map<string_view, vector<string_view>> gInsts;
  unordered_map<string_view, string_view> longRegs = {
      {"@r01", "00"}, {"@r23", "01"}, {"@r45", "10"}, {"@r67", "11"}};
  unordered_map<string_view, string_view> longRegsDirect = {
     {"r01", "00"}, {"r23", "01"}, {"r45", "10"}, {"r67", "11"}};
  size_t it;
  size_t ln;
  size_t co;
  unordered_map<string_view, size_t> labels = {};
  ofstream outfile;

public:
  App(int argc, char **argv) {

#ifdef TEST
    inputFile = "test.asm";
    outputFile = "test.bin";
#else
    inputFile = string(argv[1]);
    outputFile = string(argv[2]);
#endif

    it = 0;
    ln = 0;
    co = 0;

    gInsts["ldr"] = {"00000", "01001", "11111111", "11110110"};
    gInsts["add"] = {"00001", "01010", "11111110", "11110101"};
    gInsts["sub"] = {"00010", "01011", "11111101", "11110100"};
    gInsts["mul"] = {"00011", "01100", "11111100", "11110011"};
    gInsts["div"] = {"00100", "01101", "11111011", "11110010"};
    gInsts["and"] = {"00101", "01110", "11111010", "11110001"};
    gInsts["or"] = {"00110", "01111", "11111001", "11110000"};
    gInsts["xor"] = {"00111", "10000", "11111000", "11101111"};
    gInsts["cmp"] = {"01000", "10001", "11110111", "11101110"};
    gInsts["str"] = {"", "10010", "", "11101101"};

    onlyRegs["push"] = "10011";
    onlyRegs["pop"] = "10100";
    onlyRegs["inc"] = "10101";
    onlyRegs["dec"] = "10110";
    onlyRegs["not"] = "10111";
    onlyRegs["shr"] = "11000";
    onlyRegs["shl"] = "11001";
    onlyRegs["rtr"] = "11010";
    onlyRegs["rtl"] = "11011";

    onlyAddr["jmp"] = "11101100";
    onlyAddr["jz"] = "11101011";
    onlyAddr["je"] = "11101010";
    onlyAddr["jne"] = "11101001";
    onlyAddr["jgt"] = "11101000";
    onlyAddr["jlt"] = "11100111";
    onlyAddr["jc"] = "11100110";
    onlyAddr["jnc"] = "1110101";
    onlyAddr["call"] = "11100100";
  }

  void run() {

    tokenise();
#ifdef DEBUG
    print_tokens();
#endif

    parse(ParseStage::labels);
#ifdef DEBUG
    print_labels();
#endif

    parse(ParseStage::insts);
  }

private:
  void tokenise() {
    ifstream file(inputFile);
    string line, tok;
    while (getline(file, line)) {
      stringstream l(line);
      while (l >> tok) {
        if (tok == ";")
          break;
        tokens.push_back(tok);
      }
    }
    file.close();
  }

  void parse(ParseStage ps) {
    outfile = ofstream(outputFile);
    for (it = 0; it < tokens.size();) {
      ++ln;
      string_view ct = ntok();
      string_view nt, nnt;
      // labels
      if (ct[ct.length() - 1] == ':') {
        if (ps == ParseStage::labels) {
          string_view l = ct.substr(0, ct.length() - 1);
          labels[l] = co;
        }
      }
      // data
      else if (ct[0] == '.') {
        nt = ntok();
        if(ps == ParseStage::insts) {
          if(ct == ".b" || ct == ".db") {
            outfile << numToBin(nt) << endl;
          }
        }
        else if (ps == ParseStage::labels){
          if(ct == ".b") {
            co += 1;
          }
          else if (ct == ".db") {
            co += 2;
          }
          else if(ct == ".str"){
            assert(0 && "TODO: .str not implemented");
            stringstream ss;
            nt = ntok();
            ss << nt;
            while(nt[nt.length() - 1] != '"'){
              nt = ntok();
              ss << nt;
            } 
            cout << "got string!\n" << ss.str() << endl;
          }
        }
      }
      // insts
      // special instructions
      else if (ct == "ldsp") {
        nt = ntok();
        if (ps == ParseStage::insts) {
          outfile << "11100011\n000000" << longRegsDirect[nt] << endl;
        }
        co += 2;
      }
      // only register | push r0
      else if (onlyRegs.find(ct) != onlyRegs.end()) {
        nt = ntok();
        if (ps == ParseStage::insts) {
          outfile << onlyRegs[ct] << regToBin(nt) << endl;
        }
        co += 1;
      }
      // only address | jmp 0hffff
      else if (onlyAddr.find(ct) != onlyAddr.end()) {
        nt = ntok();
        if (ps == ParseStage::insts) {
          // if label encountered
          if (labels.find(nt) != labels.end())
            outfile << onlyAddr[ct] << "\n" << intToBin(labels[nt]) << endl;
          else
            outfile << onlyAddr[ct] << "\n" << numToBin(nt) << endl;
        }
        co += 3;
      }
      // general instructions
      else if (gInsts.find(ct) != gInsts.end()) {
        nt = ntok();
        nnt = ntok();
        // immediate | ldr r0 #0hff
        if (isReg(ps, nt) && nnt[0] == '#') {
          if (ct == "str") {
            print_err(ErrType::parse, "str not available in immediate mode",
                      ct);
          }
          if (ps == ParseStage::insts) {
            outfile << gInsts[ct][imm] << regToBin(nt) << "\n"
                    << numToBin(nnt) << endl;
          }
          co += 2;
        }
        // register direct address | ldr r0 0hffff
        else if (isReg(ps, nt) && (nnt[0] == '0')) {
          if (ps == ParseStage::insts) {
            outfile << gInsts[ct][rda] << regToBin(nt) << "\n"
                    << numToBin(nnt) << endl;
          }
          co += 3;
        }
        // register regsiter indirect | add r0 r01
        else if (isReg(ps, nt) && longRegs.find(nnt) != longRegs.end()) {
          if (ps == ParseStage::insts) {
            outfile << gInsts[ct][rria] << "\n"
                    << "000" << regToBin(nt) << longRegs[nnt] << endl;
          }
          co += 2;
        }
        // register register | sub r0 r7
        else if (isReg(ps, nt) && isReg(ps, nnt)) {
          if (ct == "str") {
            print_err(ErrType::parse,
                      "str not available in register direct mode", ct);
          }
          if (ps == ParseStage::insts) {
            outfile << gInsts[ct][rr] << "\n"
                    << "00" << regToBin(nt) << regToBin(nnt) << endl;
          }
          co += 2;
        }
        // ldr r1 l1
        else if (isReg(ps, nt)) {
          if (ps == ParseStage::insts && labels.find(nnt) != labels.end()) {
            outfile << gInsts[ct][rda] << regToBin(nt) << "\n"
                    << intToBin(labels[nnt]) << endl;
          }
          co += 3;
        } else {
          print_err(ErrType::parse, "parse failed", ct);
        }
      } else if (ct == "ret") {
        if (ps == ParseStage::insts) {
          outfile << "11100000" << endl;
        }
        co += 1;
      } else {
        print_err(ErrType::parse, "parse failed", ct);
      }
    }
    outfile.close();
  }

  bool isReg(ParseStage ps, string_view str) {
    if (str[0] == 'r' && str[1] < '8' && str[1] >= '0') {
      return true;
    } return false;
  }

  string intToBin(size_t s) {
    string k = bitset<16>(s).to_string();
    string s1 = k.substr(0, 8);
    string s2 = k.substr(8);
    return s1 + "\n" + s2;
  }

  string numToBin(string_view str) {
    string_view s;
    if (str[0] == '#') // trim #0
      s = str.substr(2);
    else {
      s = str.substr(1); // trim 0
    }
    // binary
    if (s[0] == 'b') {
      s = s.substr(1);
      if (s.length() == 16) {
        string_view s1 = s.substr(0, 8);
        string_view s2 = s.substr(8);
        return string(s1) + "\n" + string(s2);
      } else if (s.length() == 8) {
        return string(s);
      } else {
        print_err(ErrType::parse, "numToBin failed", str);
      }
    }
    // hex
    else if (s[0] == 'h') {
      s = s.substr(1);
      if (s.length() == 4) {
        return hexToBin(s[0]) + hexToBin(s[1]) + "\n" + hexToBin(s[2]) +
               hexToBin(s[3]);
      } else if (s.length() == 2) {
        return hexToBin(s[0]) + hexToBin(s[1]);
      } else {
        print_err(ErrType::parse, "numToBin failed", str);
      }
    }
    // decimal
    else if (s[0] == 'd') {
      s = s.substr(1);
      int a = stoi(string(s));
      if (a < 255) {
        return bitset<8>(a).to_string();
      } else if (a < pow(2, 16)) {
        string k = bitset<16>(a).to_string();
        string s1 = k.substr(0, 8);
        string s2 = k.substr(8);
      } else {
        print_err(ErrType::parse, "numToBin failed", str);
      }
    } else {
      print_err(ErrType::parse, "numToBin failed", str);
    }
    return "";
  }

  string_view ntok() {
    if (it < tokens.size())
      return string_view(tokens[it++].c_str());
    else {
      print_err(ErrType::parse, string("ntok failed " + tokens[it]).c_str());
      return "";
    }
  }

  string regToBin(string_view str) {
    int num = char(str[1]) - '0';
    switch (num) {
    case 0:
      return "000";
    case 1:
      return "001";
    case 2:
      return "010";
    case 3:
      return "011";
    case 4:
      return "100";
    case 5:
      return "101";
    case 6:
      return "110";
    case 7:
      return "111";
    default:
      print_err(ErrType::parse, "regToBin failed", str);
      return "";
    }
  }

  string hexToBin(const char &str) {
    switch (str) {
    case '0':
      return "0000";
    case '1':
      return "0001";
    case '2':
      return "0010";
    case '3':
      return "0011";
    case '4':
      return "0100";
    case '5':
      return "0101";
    case '6':
      return "0110";
    case '7':
      return "0111";
    case '8':
      return "1000";
    case '9':
      return "1001";
    case 'A':
    case 'a':
      return "1010";
    case 'B':
    case 'b':
      return "1011";
    case 'c':
    case 'C':
      return "1100";
    case 'D':
    case 'd':
      return "1101";
    case 'E':
    case 'e':
      return "1110";
    case 'F':
    case 'f':
      return "1111";
    default:
      print_err(ErrType::parse, "hexToBin failed");
      return "";
    }
  }

  void print_err(ErrType err, const char *msg, string_view tok = "") {
    switch (err) {
    case (ErrType::parse): {
      cout << "PARSING ERROR - " << ln << " : " << tok << " : " << msg << endl;
    }
    }
    exit(err);
  }

public:
  void print_tokens() {
    cout << "TOKENS:" << endl;
    for (string &s : tokens) {
      cout << s << " ";
    }
    cout << endl;
  }
  void print_labels() {
    cout << "LABELS:" << endl;
    for (pair<const string_view, size_t> &s : labels) {
      cout << s.first << ":" << s.second << endl;
    }
  }
};

int main(int argc, char **argv) {
  App app = App(argc, argv);
  app.run();
}
