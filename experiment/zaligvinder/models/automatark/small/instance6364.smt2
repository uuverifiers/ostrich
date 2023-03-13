(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^\d{1,3}((\.\d{1,3}){3}|(\.\d{1,3}){5})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union ((_ re.loop 3 3) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")))) ((_ re.loop 5 5) (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; /new (java|org)/Ui
(assert (str.in_re X (re.++ (str.to_re "/new ") (re.union (str.to_re "java") (str.to_re "org")) (str.to_re "/Ui\u{0a}"))))
; Host\u{3a}[^\n\r]*A-311\s+lnzzlnbk\u{2f}pkrm\.finSubject\u{3a}Basic
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "A-311") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "lnzzlnbk/pkrm.finSubject:Basic\u{0a}")))))
; ([\d]{4}[ |-]?){2}([\d]{11}[ |-]?)([\d]{2})
(assert (not (str.in_re X (re.++ ((_ re.loop 2 2) (re.++ ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}") ((_ re.loop 11 11) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-")))))))
; /^"|'+(.*)+"$|'$/
(assert (str.in_re X (re.union (str.to_re "/\u{22}") (re.++ (re.+ (str.to_re "'")) (re.+ (re.* re.allchar)) (str.to_re "\u{22}")) (str.to_re "'/\u{0a}"))))
(check-sat)
