(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([A-Z]{1,2}[0-9][0-9A-Z]?)\ ([0-9][A-Z]{2}))|(GIR\ 0AA)
(assert (str.in_re X (re.union (re.++ (str.to_re " ") ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "0" "9") (re.opt (re.union (re.range "0" "9") (re.range "A" "Z"))) (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z"))) (str.to_re "GIR 0AA\u{0a}"))))
; /\/[a-zA-Z0-9]{4,10}\.jar$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 4 10) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re ".jar/U\u{0a}")))))
; to=\x2Fezsb\s\x3Ahirmvtg\u{2f}ggqh\.kqhSPYzzzvmkituktgr\u{2f}etie
(assert (str.in_re X (re.++ (str.to_re "to=/ezsb") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ":hirmvtg/ggqh.kqh\u{1b}SPYzzzvmkituktgr/etie\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
