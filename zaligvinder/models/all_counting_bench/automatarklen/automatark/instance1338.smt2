(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; quick\x2Eqsrch\x2Ecom\s+WinSession\s+Server\u{00}
(assert (not (str.in_re X (re.++ (str.to_re "quick.qsrch.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "WinSession") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Server\u{00}\u{0a}")))))
; User-Agent\x3Awww\x2Emyarmory\x2EcomHost\x3AUser-Agent\u{3a}Host\x3AportAuthorization\u{3a}\x2Fnewsurfer4\x2F
(assert (not (str.in_re X (str.to_re "User-Agent:www.myarmory.comHost:User-Agent:Host:portAuthorization:/newsurfer4/\u{0a}"))))
; toc=MicrosoftStartupStarLoggerServerX-Mailer\u{3a}
(assert (not (str.in_re X (str.to_re "toc=MicrosoftStartupStarLoggerServerX-Mailer:\u{13}\u{0a}"))))
; ^((\d{1,3}((,\d{3})*|\d*)(\.{0,1})\d+)|\d+)$
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.union (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))) (re.* (re.range "0" "9"))) (re.opt (str.to_re ".")) (re.+ (re.range "0" "9"))) (re.+ (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}quo/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".quo/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
