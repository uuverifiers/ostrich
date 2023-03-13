(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; com\dsearch\u{2e}conduit\u{2e}com\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "com") (re.range "0" "9") (str.to_re "search.conduit.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
; \x7D\x7BTrojan\x3A\w+by\d+to\w+dddlogin\x2Edudu\x2EcomSurveillanceIPOblivion
(assert (str.in_re X (re.++ (str.to_re "}{Trojan:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "by") (re.+ (re.range "0" "9")) (str.to_re "to") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "dddlogin.dudu.comSurveillance\u{13}IPOblivion\u{0a}"))))
; PortaUser-Agent\x3AHost\x3A
(assert (str.in_re X (str.to_re "PortaUser-Agent:Host:\u{0a}")))
; ^01[0-2]{1}[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "01") ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}m4b/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4b/i\u{0a}")))))
(check-sat)
