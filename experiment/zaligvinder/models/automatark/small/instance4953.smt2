(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /load\.php\?spl=(Spreadsheet|DirectX_DS|MS09-002|MS06-006|mdac|RoxioCP v3\.2|wvf|flash|Opera_telnet|compareTo|jno|Font_FireFox|pdf_exp|aol|javad|ActiveX_pack)/U
(assert (not (str.in_re X (re.++ (str.to_re "/load.php?spl=") (re.union (str.to_re "Spreadsheet") (str.to_re "DirectX_DS") (str.to_re "MS09-002") (str.to_re "MS06-006") (str.to_re "mdac") (str.to_re "RoxioCP v3.2") (str.to_re "wvf") (str.to_re "flash") (str.to_re "Opera_telnet") (str.to_re "compareTo") (str.to_re "jno") (str.to_re "Font_FireFox") (str.to_re "pdf_exp") (str.to_re "aol") (str.to_re "javad") (str.to_re "ActiveX_pack")) (str.to_re "/U\u{0a}")))))
; /filename=[^\n]*\u{2e}tga/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tga/i\u{0a}")))))
; /^ftp\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/ftp|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
(check-sat)
