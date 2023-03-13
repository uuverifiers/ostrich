(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^-?\d+([.,]?\d+)?$
(assert (str.in_re X (re.++ (re.opt (str.to_re "-")) (re.+ (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}wri/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wri/i\u{0a}")))))
; toc=MicrosoftStartupStarLoggerServerX-Mailer\u{3a}
(assert (str.in_re X (str.to_re "toc=MicrosoftStartupStarLoggerServerX-Mailer:\u{13}\u{0a}")))
; \x2Ephp\s+Host\x3Aorigin\x3Dsidefind\u{22}The
(assert (not (str.in_re X (re.++ (str.to_re ".php") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:origin=sidefind\u{22}The\u{0a}")))))
; /STOR fp[0-9A-F]{44}\u{2e}bin/
(assert (not (str.in_re X (re.++ (str.to_re "/STOR fp") ((_ re.loop 44 44) (re.union (re.range "0" "9") (re.range "A" "F"))) (str.to_re ".bin/\u{0a}")))))
(check-sat)
