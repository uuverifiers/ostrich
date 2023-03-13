(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[1-9]{1,2}(.5)?$
(assert (str.in_re X (re.++ ((_ re.loop 1 2) (re.range "1" "9")) (re.opt (re.++ re.allchar (str.to_re "5"))) (str.to_re "\u{0a}"))))
; hirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (str.in_re X (str.to_re "hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}")))
; ".*?"|".*$|'.*?'|'.*$
(assert (str.in_re X (re.union (re.++ (str.to_re "\u{22}") (re.* re.allchar) (str.to_re "\u{22}")) (re.++ (str.to_re "\u{22}") (re.* re.allchar)) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "'")) (re.++ (str.to_re "'") (re.* re.allchar) (str.to_re "\u{0a}")))))
(check-sat)
