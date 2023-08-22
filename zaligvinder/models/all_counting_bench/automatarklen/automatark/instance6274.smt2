(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; LOG\s+spyblpatHost\x3Ais\x2Ephp
(assert (not (str.in_re X (re.++ (str.to_re "LOG") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpatHost:is.php\u{0a}")))))
; \.cfg.*spyblini\x2Eini[^\n\r]*urfiqileuq\u{2f}tjzu.*Host\x3A666password\x3B1\x3BOptixGmbHPG=SPEEDBARcuReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".cfg") (re.* re.allchar) (str.to_re "spyblini.ini") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "urfiqileuq/tjzu") (re.* re.allchar) (str.to_re "Host:666password;1;OptixGmbHPG=SPEEDBARcuReferer:\u{0a}")))))
; ^((\d(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{2}(\u{20})\d{3}(\u{20})\d{3}((\u{20})\d{2}|))|(\d\d{2}\d{2}\d{2}\d{3}\d{3}(\d{2}|)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.range "0" "9") (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re " ") ((_ re.loop 2 2) (re.range "0" "9"))) (re.++ (re.range "0" "9") ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; %3f\s+url=[^\n\r]*httpUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "%3f") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "url=") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "httpUser-Agent:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
