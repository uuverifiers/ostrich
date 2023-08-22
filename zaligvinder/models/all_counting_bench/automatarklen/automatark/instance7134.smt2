(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Host\u{3a}[^\n]+\u{3a}\d+\u{0d}\u{0a}/
(assert (not (str.in_re X (re.++ (str.to_re "/Host:") (re.+ (re.comp (str.to_re "\u{0a}"))) (str.to_re ":") (re.+ (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/\u{0a}")))))
; /^(8-?|\+?7-?)?(\(?\d{3}\)?)-?(\d-?){6}\d$/
(assert (str.in_re X (re.++ (str.to_re "/") (re.opt (re.union (re.++ (str.to_re "8") (re.opt (str.to_re "-"))) (re.++ (re.opt (str.to_re "+")) (str.to_re "7") (re.opt (str.to_re "-"))))) (re.opt (str.to_re "-")) ((_ re.loop 6 6) (re.++ (re.range "0" "9") (re.opt (str.to_re "-")))) (re.range "0" "9") (str.to_re "/\u{0a}") (re.opt (str.to_re "(")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ")")))))
; /\u{2f}[A-F0-9]{158}/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 158 158) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; /\/load_module\.php\?user\=(n1|1|2|11)$/U
(assert (not (str.in_re X (re.++ (str.to_re "//load_module.php?user=") (re.union (str.to_re "n1") (str.to_re "1") (str.to_re "2") (str.to_re "11")) (str.to_re "/U\u{0a}")))))
; (^\d{1,5}$|^\d{1,5}\.\d{1,2}$)
(assert (not (str.in_re X (re.++ (re.union ((_ re.loop 1 5) (re.range "0" "9")) (re.++ ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
