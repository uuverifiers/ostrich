(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Efreescratchandwin\x2Ecom\w+Port.*User-Agent\x3AToolbarkit
(assert (str.in_re X (re.++ (str.to_re "www.freescratchandwin.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Port") (re.* re.allchar) (str.to_re "User-Agent:Toolbarkit\u{0a}"))))
; ^[-+]?(\d?\d?\d?,?)?(\d{3}\,?)*(\.\d{1,2})?$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.opt (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re ",")))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
