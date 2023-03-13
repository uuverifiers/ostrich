(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \u{28}BDLL\u{29}\s+CD\x2F.*Host\x3A
(assert (str.in_re X (re.++ (str.to_re "(BDLL)\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "CD/") (re.* re.allchar) (str.to_re "Host:\u{0a}"))))
; /^\/[-\w]{70,78}==?$/U
(assert (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 70 78) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "=") (re.opt (str.to_re "=")) (str.to_re "/U\u{0a}"))))
; ^[a-zA-Z]{1}[0-9]{1}[a-zA-Z]{1}[- ]{0,1}[0-9]{1}[a-zA-Z]{1}[0-9]{1}
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (antifraud\.ref\.num)[0-9]*(@citibank\.com)
(assert (not (str.in_re X (re.++ (str.to_re "antifraud.ref.num") (re.* (re.range "0" "9")) (str.to_re "@citibank.com\u{0a}")))))
(check-sat)
