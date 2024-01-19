(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; User-Agent\x3Atwfofrfzlugq\u{2f}eve\.qduuid=ppcdomain\x2Eco\x2EukGuardedReferer\x3AreadyLOGUser-Agent\x3A
(assert (str.in_re X (str.to_re "User-Agent:twfofrfzlugq/eve.qduuid=ppcdomain.co.ukGuardedReferer:readyLOGUser-Agent:\u{0a}")))
; /\/AES\d{9}O\d{4,5}\u{2e}jsp/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//AES") ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "O") ((_ re.loop 4 5) (re.range "0" "9")) (str.to_re ".jsp/Ui\u{0a}")))))
; ^[0][1-9]{2}(-)[0-9]{8}$  and  ^[0][1-9]{3}(-)[0-9]{7}$  and  ^[0][1-9]{4}(-)[0-9]{6}$
(assert (not (str.in_re X (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 3 3) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "  and  0") ((_ re.loop 4 4) (re.range "1" "9")) (str.to_re "-") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
