(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; linkautomatici\x2EcomAID\x2FYourUser-Agent\x3AtoBasicwww\x2Ewebcruiser\x2Ecc
(assert (not (str.in_re X (str.to_re "linkautomatici.comAID/YourUser-Agent:toBasicwww.webcruiser.cc\u{0a}"))))
; (\d+)?-?(\d+)-(\d+)
(assert (not (str.in_re X (re.++ (re.opt (re.+ (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (str.to_re "-") (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}met/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".met/i\u{0a}")))))
; /\xFF\xFE\x3F\u{10}\u{00}\u{00}.{14}[\x2Bx\x2Fa-z0-9]{20}/smi
(assert (str.in_re X (re.++ (str.to_re "/\u{ff}\u{fe}?\u{10}\u{00}\u{00}") ((_ re.loop 14 14) re.allchar) ((_ re.loop 20 20) (re.union (str.to_re "+") (str.to_re "x") (str.to_re "/") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/smi\u{0a}"))))
; Host\u{3a}\s+e2give\.com\s+NETObservemedia\x2Edxcdirect\x2EcomSubject\x3Aquick\x2Eqsrch\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "e2give.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "NETObservemedia.dxcdirect.comSubject:quick.qsrch.com\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
