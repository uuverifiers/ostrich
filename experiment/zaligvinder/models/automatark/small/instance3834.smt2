(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?){1}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.* ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/")))) (re.opt (re.union (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "=")) (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "+") (str.to_re "/"))) (str.to_re "==")))))) (str.to_re "\u{0a}")))))
; /load\.php\?spl=(Spreadsheet|DirectX_DS|MS09-002|MS06-006|mdac|RoxioCP v3\.2|wvf|flash|Opera_telnet|compareTo|jno|Font_FireFox|pdf_exp|aol|javad|ActiveX_pack)/U
(assert (str.in_re X (re.++ (str.to_re "/load.php?spl=") (re.union (str.to_re "Spreadsheet") (str.to_re "DirectX_DS") (str.to_re "MS09-002") (str.to_re "MS06-006") (str.to_re "mdac") (str.to_re "RoxioCP v3.2") (str.to_re "wvf") (str.to_re "flash") (str.to_re "Opera_telnet") (str.to_re "compareTo") (str.to_re "jno") (str.to_re "Font_FireFox") (str.to_re "pdf_exp") (str.to_re "aol") (str.to_re "javad") (str.to_re "ActiveX_pack")) (str.to_re "/U\u{0a}"))))
(check-sat)
