(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[A-Za-z]{2}[0-9]{6}[A-Za-z]{1}$
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.union (re.range "A" "Z") (re.range "a" "z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; \x2Fnewsurfer4\x2FOK\r\nencodertvlistingsTM_SEARCH3
(assert (str.in_re X (str.to_re "/newsurfer4/OK\u{0d}\u{0a}encodertvlistingsTM_SEARCH3\u{0a}")))
; /filename=[^\n]*\u{2e}rtx/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rtx/i\u{0a}")))))
(check-sat)
