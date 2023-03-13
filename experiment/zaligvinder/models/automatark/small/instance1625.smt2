(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Esnap\x2Ecom\w+FTX-Mailer\x3AfromReferer\x3Asearch\u{2e}conduit\u{2e}com
(assert (not (str.in_re X (re.++ (str.to_re "www.snap.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "FTX-Mailer:\u{13}fromReferer:search.conduit.com\u{0a}")))))
; ^[a-zA-Z][a-zA-Z0-9_]+$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "A" "Z")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; [0-9]+
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (str.to_re "\u{0a}"))))
; [:]{1}[-~+o]?[)>]+
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re ":")) (re.opt (re.union (str.to_re "-") (str.to_re "~") (str.to_re "+") (str.to_re "o"))) (re.+ (re.union (str.to_re ")") (str.to_re ">"))) (str.to_re "\u{0a}"))))
(check-sat)
