(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; MyHost\x3AtoHost\x3AWinSessionwww\u{2e}urlblaze\u{2e}netResultHost\x3A
(assert (not (str.in_re X (str.to_re "MyHost:toHost:WinSessionwww.urlblaze.netResultHost:\u{0a}"))))
; (^(6334)[5-9](\d{11}$|\d{13,14}$))
(assert (str.in_re X (re.++ (str.to_re "\u{0a}6334") (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)
