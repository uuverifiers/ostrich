(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\d+Subject\x3Aas\x2Estarware\x2Ecom\x2Fdp\x2Fsearch\?x=
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.range "0" "9")) (str.to_re "Subject:as.starware.com/dp/search?x=\u{0a}")))))
; ^(X(-|\.)?0?\d{7}(-|\.)?[A-Z]|[A-Z](-|\.)?\d{7}(-|\.)?[0-9A-Z]|\d{8}(-|\.)?[A-Z])$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "X") (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.opt (str.to_re "0")) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z")) (re.++ (re.range "A" "Z") (re.opt (re.union (str.to_re "-") (str.to_re "."))) ((_ re.loop 7 7) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.++ ((_ re.loop 8 8) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re "."))) (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /\u{2e}dcr([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dcr") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^(0{1})([1-9]{2})(\s|-|.{0,1})(\d{3})(\s|-|.{0,1})(\d{2})(\s|-|.{0,1})(\d{2})$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (str.to_re "0")) ((_ re.loop 2 2) (re.range "1" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re "-") (re.opt re.allchar) (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fsearchfast\x2FNavhelper
(assert (str.in_re X (str.to_re "/searchfast/Navhelper\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
