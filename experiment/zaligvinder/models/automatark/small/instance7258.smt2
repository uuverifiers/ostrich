(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; zopabora\x2EinfocomhoroscopeTravelInsidefromUser-Agent\x3AFrom\x3Awww\x2EZSearchResults\x2EcomExplorer
(assert (not (str.in_re X (str.to_re "zopabora.infocomhoroscopeTravelInsidefromUser-Agent:From:www.ZSearchResults.com\u{13}Explorer\u{0a}"))))
; ^[+]\d{1,2}\(\d{2,3}\)\d{6,8}(\#\d{1,10})?$
(assert (not (str.in_re X (re.++ (str.to_re "+") ((_ re.loop 1 2) (re.range "0" "9")) (str.to_re "(") ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ")") ((_ re.loop 6 8) (re.range "0" "9")) (re.opt (re.++ (str.to_re "#") ((_ re.loop 1 10) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; zopabora\x2Einfo\s+Inside.*User-Agent\x3A\s+SystemSleuthserverUser-Agent\u{3a}\x2Fnewsurfer4\x2FMicrosoft
(assert (str.in_re X (re.++ (str.to_re "zopabora.info") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Inside") (re.* re.allchar) (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "SystemSleuth\u{13}serverUser-Agent:/newsurfer4/Microsoft\u{0a}"))))
; /filename=[^\n]*\u{2e}scr/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".scr/i\u{0a}")))))
(check-sat)
