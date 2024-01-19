(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^((5)/(1|2|5)/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([0-9])/([2-9]))$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}5/") (re.union (str.to_re "1") (str.to_re "2") (str.to_re "5")) (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "0" "9") (str.to_re "/") (re.range "2" "9"))))
; toc=MicrosoftStartupStarLoggerServerX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "toc=MicrosoftStartupStarLoggerServerX-Mailer:\u{13}\u{0a}"))))
; X-Mailer\u{3a}\s+cyber@yahoo\x2EcomcuAgent
(assert (not (str.in_re X (re.++ (str.to_re "X-Mailer:\u{13}") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "cyber@yahoo.comcuAgent\u{0a}")))))
; [0](\d{9})|([0](\d{2})( |-|)((\d{3}))( |-|)(\d{4}))|[0](\d{2})( |-|)(\d{7})|(\+|00|09)(\d{2}|\d{3})( |-|)(\d{2})( |-|)((\d{3}))( |-|)(\d{4})
(assert (not (str.in_re X (re.union (re.++ (str.to_re "0") ((_ re.loop 9 9) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "0") ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 7 7) (re.range "0" "9"))) (re.++ (re.union (str.to_re "+") (str.to_re "00") (str.to_re "09")) (re.union ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))))
; /filename=[^\n]*\u{2e}rmp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rmp/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
