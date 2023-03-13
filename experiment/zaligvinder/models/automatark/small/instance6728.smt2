(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (")([0-9]*)(",")([0-9]*)("\))
(assert (str.in_re X (re.++ (str.to_re "\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22},\u{22}") (re.* (re.range "0" "9")) (str.to_re "\u{22})\u{0a}"))))
; TROJAN-Owner\x3AUser-Agent\u{3a}%3fTs2\x2F
(assert (str.in_re X (str.to_re "TROJAN-Owner:User-Agent:%3fTs2/\u{0a}")))
; (:(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3}))?
(assert (not (str.in_re X (re.++ (re.opt (re.++ (str.to_re ":") (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (re.range "1" "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (re.range "1" "9") ((_ re.loop 0 3) (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
(check-sat)
