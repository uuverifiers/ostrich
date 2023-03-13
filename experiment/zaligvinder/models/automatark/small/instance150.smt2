(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-]?([1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|\.[0-9]{1,2})$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.union (re.++ ((_ re.loop 1 1) (re.range "1" "9")) (re.* (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re "0") (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9"))))) (re.++ (str.to_re ".") ((_ re.loop 1 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Server\u{00}\s+SbAts\s+versionetbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (re.++ (str.to_re "Server\u{00}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SbAts") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "versionetbuviaebe/eqv.bvv\u{0a}")))))
; Host\u{3a}\s+www\s+Host\x3AHost\x3AIPAsynchaveAdToolszopabora\x2EinfoHost\u{3a}
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:IPAsynchaveAdToolszopabora.infoHost:\u{0a}")))))
; /^[014567d]-/R
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (str.to_re "0") (str.to_re "1") (str.to_re "4") (str.to_re "5") (str.to_re "6") (str.to_re "7") (str.to_re "d")) (str.to_re "-/R\u{0a}")))))
; /filename=[^\n]*\u{2e}doc/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".doc/i\u{0a}")))))
(check-sat)
