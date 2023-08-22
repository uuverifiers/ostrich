(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\u{3a}[^\n\r]*pgwtjgxwthx\u{2f}byb\.xky[^\n\r]*source%3Dultrasearch136%26campaign%3Dsnap
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "pgwtjgxwthx/byb.xky") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}"))))
; Referer\x3A.*User-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "Referer:") (re.* re.allchar) (str.to_re "User-Agent:\u{0a}"))))
; ^([51|52|53|54|55]{2})([0-9]{14})$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (str.to_re "5") (str.to_re "1") (str.to_re "|") (str.to_re "2") (str.to_re "3") (str.to_re "4"))) ((_ re.loop 14 14) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^\d{1,8}$|^\d{1,3},\d{3}$|^\d{1,2},\d{3},\d{3}$
(assert (not (str.in_re X (re.union ((_ re.loop 1 8) (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
(assert (> (str.len X) 10))
(check-sat)
