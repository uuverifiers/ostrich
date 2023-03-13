(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; as\x2Estarware\x2Ecom%3fUser-Agent\x3Ahostie
(assert (not (str.in_re X (str.to_re "as.starware.com%3fUser-Agent:hostie\u{0a}"))))
; ( xmlns:.*=[",'].*[",'])|( xmlns=[",'].*[",'])
(assert (str.in_re X (re.union (re.++ (str.to_re " xmlns:") (re.* re.allchar) (str.to_re "=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))) (re.++ (str.to_re "\u{0a} xmlns=") (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'")) (re.* re.allchar) (re.union (str.to_re "\u{22}") (str.to_re ",") (str.to_re "'"))))))
; User-Agent\x3ASurveillancecomOnline
(assert (str.in_re X (str.to_re "User-Agent:Surveillance\u{13}comOnline\u{0a}")))
; e2give\.comrichfind\x2Ecom\u{22}007User-Agent\x3Awww\x2Esearchreslt\x2Ecom
(assert (not (str.in_re X (str.to_re "e2give.comrichfind.com\u{22}007User-Agent:www.searchreslt.com\u{0a}"))))
; ^((\+)?(\d{2})[-])?(([\(])?((\d){3,5})([\)])?[-])|(\d{3,5})(\d{5,8}){1}?$
(assert (not (str.in_re X (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-"))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (str.to_re "-")) (re.++ ((_ re.loop 3 5) (re.range "0" "9")) ((_ re.loop 1 1) ((_ re.loop 5 8) (re.range "0" "9"))) (str.to_re "\u{0a}"))))))
(check-sat)
