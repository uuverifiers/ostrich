(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}xcf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xcf/i\u{0a}"))))
; A-311[^\n\r]*Attached\sHost\x3AWordmyway\.comhoroscope2
(assert (str.in_re X (re.++ (str.to_re "A-311") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Attached") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "Host:Wordmyway.comhoroscope2\u{0a}"))))
; encoder[^\n\r]*\.cfg\s+Host\x3AWeHost\u{3a}
(assert (str.in_re X (re.++ (str.to_re "encoder") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re ".cfg") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:WeHost:\u{0a}"))))
; ^[-+]?\d+([.,]\d{0,2}){0,1}$
(assert (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re ",")) ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
(check-sat)
