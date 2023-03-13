(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Iterenet\s+www\x2Emirarsearch\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Iterenet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.mirarsearch.comHost:\u{0a}")))))
; [A-Z][a-z]+
(assert (not (str.in_re X (re.++ (re.range "A" "Z") (re.+ (re.range "a" "z")) (str.to_re "\u{0a}")))))
; /^tcpdata\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/tcpdata|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; (((\+44)? ?(\(0\))? ?)|(0))( ?[0-9]{3,4}){3}
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.opt (str.to_re "+44")) (re.opt (str.to_re " ")) (re.opt (str.to_re "(0)")) (re.opt (str.to_re " "))) (str.to_re "0")) ((_ re.loop 3 3) (re.++ (re.opt (str.to_re " ")) ((_ re.loop 3 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Pre.*Keyloggeradfsgecoiwnfhirmvtg\u{2f}ggqh\.kqh
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.* re.allchar) (str.to_re "Keyloggeradfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}\u{0a}")))))
(check-sat)
