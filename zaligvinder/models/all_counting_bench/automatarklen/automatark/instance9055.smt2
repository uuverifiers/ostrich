(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; zopabora\x2Einfo\s+Inside.*User-Agent\x3A\s+SystemSleuthserverUser-Agent\u{3a}\x2Fnewsurfer4\x2FMicrosoft
(assert (not (str.in_re X (re.++ (str.to_re "zopabora.info") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Inside") (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SystemSleuth\u{13}serverUser-Agent:/newsurfer4/Microsoft\u{0a}")))))
; Current[^\n\r]*server[^\n\r]*Host\x3Aocllceclbhs\u{2f}gth
(assert (str.in_re X (re.++ (str.to_re "Current") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "server") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:ocllceclbhs/gth\u{0a}"))))
; /filename=[^\n]*\u{2e}vqf/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vqf/i\u{0a}"))))
; ^(\d?)*\.?(\d{1}|\d{2})?$
(assert (not (str.in_re X (re.++ (re.* (re.opt (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.opt (re.union ((_ re.loop 1 1) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
