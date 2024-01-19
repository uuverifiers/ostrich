(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \D
(assert (not (str.in_re X (re.++ (re.comp (re.range "0" "9")) (str.to_re "\u{0a}")))))
; User-Agent\x3AFrom\x3Awww\x2Eonlinecasinoextra\x2EcomHost\x3A
(assert (str.in_re X (str.to_re "User-Agent:From:www.onlinecasinoextra.comHost:\u{0a}")))
; ^[0-3][0-9][0-1]\d{3}-\d{4}?
(assert (not (str.in_re X (re.++ (re.range "0" "3") (re.range "0" "9") (re.range "0" "1") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
