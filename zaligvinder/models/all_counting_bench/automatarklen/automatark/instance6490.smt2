(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora\x2Einfo
(assert (str.in_re X (str.to_re "source%3Dultrasearch136%26campaign%3DsnapuplogWinInet3Azopabora.info\u{0a}")))
; /\/r_autoidcnt\.asp\?mer_seq=\d[^\r\n]*\u{26}mac=/Ui
(assert (str.in_re X (re.++ (str.to_re "//r_autoidcnt.asp?mer_seq=") (re.range "0" "9") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "&mac=/Ui\u{0a}"))))
; /filename=[^\n]*\u{2e}sln/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".sln/i\u{0a}")))))
; ([+(]?\d{0,2}[)]?)([-/.\s]?\d+)+
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "/") (str.to_re ".") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "+") (str.to_re "("))) ((_ re.loop 0 2) (re.range "0" "9")) (re.opt (str.to_re ")"))))))
; /^[1-9][0-9][0-9][0-9][0-9][0-9]$/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "1" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
