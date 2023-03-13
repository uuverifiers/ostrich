(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([1-9]+\d{0,2},(\d{3},)*\d{3}(\.\d{1,2})?|[1-9]+\d*(\.\d{1,2})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.+ (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9"))))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; [+]?[ ]?\d{1,3}[ ]?\d{1,3}[- ]?\d{4}[- ]?\d{4}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; Keylogger\w+Owner\x3A\dBetaWordixqshv\u{2f}qzccsServer\u{00}MyBYReferer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}
(assert (str.in_re X (re.++ (str.to_re "Keylogger") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.range "0" "9") (str.to_re "BetaWordixqshv/qzccsServer\u{00}MyBYReferer:www.ccnnlc.com\u{13}\u{04}\u{00}\u{0a}"))))
; ^.*(([^\.][\.][wW][mM][aA])|([^\.][\.][mM][pP][3]))$
(assert (str.in_re X (re.++ (re.* re.allchar) (re.union (re.++ (re.comp (str.to_re ".")) (str.to_re ".") (re.union (str.to_re "w") (str.to_re "W")) (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "a") (str.to_re "A"))) (re.++ (re.comp (str.to_re ".")) (str.to_re ".") (re.union (str.to_re "m") (str.to_re "M")) (re.union (str.to_re "p") (str.to_re "P")) (str.to_re "3"))) (str.to_re "\u{0a}"))))
(check-sat)
