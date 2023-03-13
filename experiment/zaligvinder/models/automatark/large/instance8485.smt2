(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Guarded\s+ready\w+PARSERHost\u{3a}A-311ServerUser-Agent\x3Ascn\u{2e}mystoretoolbar\u{2e}com
(assert (str.in_re X (re.++ (str.to_re "Guarded") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ready") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "PARSERHost:A-311ServerUser-Agent:scn.mystoretoolbar.com\u{13}\u{0a}"))))
; ^([0-9]{12},)+[0-9]{12}$|^([0-9]{12})$
(assert (not (str.in_re X (re.union (re.++ (re.+ (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 12 12) (re.range "0" "9"))) (re.++ ((_ re.loop 12 12) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; ((\(?\d{2,5}\)?)?(\d|-| )?(15((\d|-| ){6,13})))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.opt (re.++ (re.opt (str.to_re "(")) ((_ re.loop 2 5) (re.range "0" "9")) (re.opt (str.to_re ")")))) (re.opt (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " "))) (str.to_re "15") ((_ re.loop 6 13) (re.union (re.range "0" "9") (str.to_re "-") (str.to_re " ")))))))
; /filename=[^\n]*\u{2e}plf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".plf/i\u{0a}"))))
(check-sat)
