(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}dws/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dws/i\u{0a}"))))
; /filename=[^\n]*\u{2e}rdp/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rdp/i\u{0a}")))))
; <title>(.*?)</title>
(assert (str.in_re X (re.++ (str.to_re "<title>") (re.* re.allchar) (str.to_re "</title>\u{0a}"))))
; /filename=[^\n]*\u{2e}csd/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".csd/i\u{0a}"))))
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")"))))))
(assert (> (str.len X) 10))
(check-sat)
