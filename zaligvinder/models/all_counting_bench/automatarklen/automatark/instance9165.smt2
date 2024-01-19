(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(((0|((\+)?91(\-)?))|((\((\+)?91\)(\-)?)))?[7-9]\d{9})?$
(assert (not (str.in_re X (re.++ (re.opt (re.++ (re.opt (re.union (re.++ (str.to_re "(") (re.opt (str.to_re "+")) (str.to_re "91)") (re.opt (str.to_re "-"))) (str.to_re "0") (re.++ (re.opt (str.to_re "+")) (str.to_re "91") (re.opt (str.to_re "-"))))) (re.range "7" "9") ((_ re.loop 9 9) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \u{28}robert\u{40}blackcastlesoft\x2Ecom\u{29}
(assert (not (str.in_re X (str.to_re "(robert@blackcastlesoft.com)\u{0a}"))))
; ([A-Za-z]{0,}[\.\,\s]{0,}[A-Za-z]{1,}[\.\s]{1,}[0-9]{1,2}[\,\s]{0,}[0-9]{4})| ([0-9]{0,4}[-,\s]{0,}[A-Za-z]{3,9}[-,\s]{0,}[0-9]{1,2}[-,\s]{0,}[A-Za-z]{0,8})| ([0-9]{1,4}[\/\.\-][0-9]{1,4}[\/\.\-][0-9]{1,4})
(assert (not (str.in_re X (re.union (re.++ (re.* (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.union (str.to_re ".") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.+ (re.union (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.union (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re " ") ((_ re.loop 0 4) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 3 9) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.* (re.union (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 2) (re.range "0" "9")) (re.* (re.union (str.to_re "-") (str.to_re ",") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 0 8) (re.union (re.range "A" "Z") (re.range "a" "z")))) (re.++ (str.to_re " \u{0a}") ((_ re.loop 1 4) (re.range "0" "9")) (re.union (str.to_re "/") (str.to_re ".") (str.to_re "-")) ((_ re.loop 1 4) (re.range "0" "9")) (re.union (str.to_re "/") (str.to_re ".") (str.to_re "-")) ((_ re.loop 1 4) (re.range "0" "9")))))))
; clvompycem\u{2f}cen\.vcnHost\x3AUser-Agent\x3A\u{0d}\u{0a}
(assert (str.in_re X (str.to_re "clvompycem/cen.vcnHost:User-Agent:\u{0d}\u{0a}\u{0a}")))
(assert (> (str.len X) 10))
(check-sat)
