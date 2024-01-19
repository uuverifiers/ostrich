(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}dib([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.dib") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ovplEchelonUser-Agent\x3AUser-Agent\x3AHost\u{3a}
(assert (str.in_re X (str.to_re "ovplEchelonUser-Agent:User-Agent:Host:\u{0a}")))
; ^([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}$
(assert (str.in_re X (re.++ ((_ re.loop 7 7) (re.++ ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re ":"))) ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "A" "F") (re.range "a" "f"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
