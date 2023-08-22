(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; pgwtjgxwthx\u{2f}byb\.xkyLOGurl=enews\x2Eearthlink\x2Enet
(assert (not (str.in_re X (str.to_re "pgwtjgxwthx/byb.xkyLOGurl=enews.earthlink.net\u{0a}"))))
; ^([0-9a-f]{4}\.[0-9a-f]{4}\.[0-9a-f]{4})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ".") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ".") ((_ re.loop 4 4) (re.union (re.range "0" "9") (re.range "a" "f"))))))
; ^[6]\d{7}$
(assert (not (str.in_re X (re.++ (str.to_re "6") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \stoolbar\.anwb\.nl.*Host\x3A
(assert (not (str.in_re X (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toolbar.anwb.nl") (re.* re.allchar) (str.to_re "Host:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
