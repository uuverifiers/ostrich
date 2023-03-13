(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^([1-3]{1}[0-9]{0,}(\.[0-9]{1})?|0(\.[0-9]{1})?|[4]{1}[0-9]{0,}(\.[0]{1})?|5(\.[5]{1}))$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "3")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (re.range "0" "9"))))) (re.++ ((_ re.loop 1 1) (str.to_re "4")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 1 1) (str.to_re "0"))))) (re.++ (str.to_re "5.") ((_ re.loop 1 1) (str.to_re "5")))) (str.to_re "\u{0a}"))))
; ^(smtp)\.([\w\-]+)\.[\w\-]{2,3}$
(assert (not (str.in_re X (re.++ (str.to_re "smtp.") (re.+ (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 3) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}")))))
; e2give\.comrichfind\x2Ecom\u{22}007User-Agent\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "e2give.comrichfind.com\u{22}007User-Agent:www.searchreslt.com\u{0a}")))
(check-sat)
