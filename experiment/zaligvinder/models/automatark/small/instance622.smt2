(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\d{1,3},(\d{3},)*\d{3}(\.\d{1,3})?|\d{1,3}(\.\d{3})?)$
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ",") (re.* (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; e2give\.comrichfind\x2Ecom\u{22}007User-Agent\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "e2give.comrichfind.com\u{22}007User-Agent:www.searchreslt.com\u{0a}")))
(check-sat)
