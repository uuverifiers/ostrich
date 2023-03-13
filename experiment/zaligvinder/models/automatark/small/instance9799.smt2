(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}vwr/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vwr/i\u{0a}"))))
; /filename=[^\n]*\u{2e}wal/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wal/i\u{0a}")))))
; Host\x3AIPAsynchaveAdToolszopabora\x2Einfo
(assert (not (str.in_re X (str.to_re "Host:IPAsynchaveAdToolszopabora.info\u{0a}"))))
; ^((5[1-5])([0-9]{2})((-|\s)?[0-9]{4}){3})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "5") (re.range "1" "5"))))
(check-sat)
