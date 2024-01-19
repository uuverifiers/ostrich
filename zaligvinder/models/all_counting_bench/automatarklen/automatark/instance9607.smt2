(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\x2Faws\d{1,5}\.jsp\x3F/i
(assert (str.in_re X (re.++ (str.to_re "//aws") ((_ re.loop 1 5) (re.range "0" "9")) (str.to_re ".jsp?/i\u{0a}"))))
; ^([a-zA-Z]+[\'\,\.\-]?[a-zA-Z ]*)+[ ]([a-zA-Z]+[\'\,\.\-]?[a-zA-Z ]+)+$
(assert (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-"))) (re.* (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " "))))) (str.to_re " ") (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.union (str.to_re "'") (str.to_re ",") (str.to_re ".") (str.to_re "-"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re " "))))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
