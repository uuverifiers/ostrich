(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(LV-)[0-9]{4}$
(assert (str.in_re X (re.++ (str.to_re "LV-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; hirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (not (str.in_re X (str.to_re "hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
