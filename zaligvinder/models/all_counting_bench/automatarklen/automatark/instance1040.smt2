(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3A\x2Ftba\x2FFrom\x3A
(assert (str.in_re X (str.to_re "User-Agent:/tba/From:\u{0a}")))
; Iterenet\s+www\x2Emirarsearch\x2EcomHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Iterenet") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.mirarsearch.comHost:\u{0a}")))))
; ^([A-Z]{1}\w{1,3}) (\d{1}[A-Z]{2})$
(assert (not (str.in_re X (re.++ (str.to_re " \u{0a}") ((_ re.loop 1 1) (re.range "A" "Z")) ((_ re.loop 1 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "A" "Z"))))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\d+Ready
(assert (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.range "0" "9")) (str.to_re "Ready\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
