(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; gdvsotuqwsg\u{2f}dxt\.hdFrom\u{3a}hirmvtg\u{2f}ggqh\.kqh
(assert (str.in_re X (str.to_re "gdvsotuqwsg/dxt.hdFrom:hirmvtg/ggqh.kqh\u{1b}\u{0a}")))
; ^(.|\n){0,16}$
(assert (not (str.in_re X (re.++ ((_ re.loop 0 16) (re.union re.allchar (str.to_re "\u{0a}"))) (str.to_re "\u{0a}")))))
; [0-9]{5}\s?[0-9]{5}
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^[1-9]{1}[0-9]{3} ?[A-Z]{2}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "A" "Z")) (str.to_re "\u{0a}"))))
(check-sat)
