(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(20|21|22|23|[01]\d|\d)(([:.][0-5]\d){1,2})$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "20") (str.to_re "21") (str.to_re "22") (str.to_re "23") (re.++ (re.union (str.to_re "0") (str.to_re "1")) (re.range "0" "9")) (re.range "0" "9")) ((_ re.loop 1 2) (re.++ (re.union (str.to_re ":") (str.to_re ".")) (re.range "0" "5") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; e2give\.comrichfind\x2Ecom\u{22}007User-Agent\x3Awww\x2Esearchreslt\x2Ecom
(assert (str.in_re X (str.to_re "e2give.comrichfind.com\u{22}007User-Agent:www.searchreslt.com\u{0a}")))
; X-OSSproxy\u{3a}\dMicrosoft\x2APORT3\x2AProLive\+Version\+3A
(assert (str.in_re X (re.++ (str.to_re "X-OSSproxy:") (re.range "0" "9") (str.to_re "Microsoft*PORT3*ProLive+Version+3A\u{0a}"))))
; /filename=[^\n]*\u{2e}zip/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".zip/i\u{0a}")))))
; ^0$|^0\.{1}(\d{1,2})$|^[1-9]{1}[0-9]*\.?(\d{1,2})$|^[1-9]+[0-9]*$
(assert (str.in_re X (re.union (str.to_re "0") (re.++ (str.to_re "0") ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (str.to_re ".")) ((_ re.loop 1 2) (re.range "0" "9"))) (re.++ (re.+ (re.range "1" "9")) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
