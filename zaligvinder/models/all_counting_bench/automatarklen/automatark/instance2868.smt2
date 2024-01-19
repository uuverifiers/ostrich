(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2f}\?ts\u{3d}[a-f0-9]{40}\u{26}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?ts=") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&/Ui\u{0a}")))))
; httphostHost\u{3a}Agent\u{22}
(assert (str.in_re X (str.to_re "httphostHost:Agent\u{22}\u{0a}")))
; \x2Frss\d+answer\sHost\x3A
(assert (not (str.in_re X (re.++ (str.to_re "/rss") (re.+ (re.range "0" "9")) (str.to_re "answer") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
