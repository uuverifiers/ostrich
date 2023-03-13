(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; CUSTOM\swww\x2Elocators\x2Ecomas\x2Estarware\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "CUSTOM") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "www.locators.comas.starware.com\u{0a}"))))
; \.cfg.*spyblini\x2Eini[^\n\r]*urfiqileuq\u{2f}tjzu.*Host\x3A666password\x3B1\x3BOptixGmbHPG=SPEEDBARcuReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".cfg") (re.* re.allchar) (str.to_re "spyblini.ini") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "urfiqileuq/tjzu") (re.* re.allchar) (str.to_re "Host:666password;1;OptixGmbHPG=SPEEDBARcuReferer:\u{0a}")))))
; /filename=[^\n]*\u{2e}mp3/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mp3/i\u{0a}")))))
; ^( [1-9]|[1-9]|0[1-9]|10|11|12)[0-5]\d$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re " ") (re.range "1" "9")) (re.range "1" "9") (re.++ (str.to_re "0") (re.range "1" "9")) (str.to_re "10") (str.to_re "11") (str.to_re "12")) (re.range "0" "5") (re.range "0" "9") (str.to_re "\u{0a}")))))
; [NS] \d{1,}(\:[0-5]\d){2}.{0,1}\d{0,},[EW] \d{1,}(\:[0-5]\d){2}.{0,1}\d{0,}
(assert (str.in_re X (re.++ (re.union (str.to_re "N") (str.to_re "S")) (str.to_re " ") (re.+ (re.range "0" "9")) ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt re.allchar) (re.* (re.range "0" "9")) (str.to_re ",") (re.union (str.to_re "E") (str.to_re "W")) (str.to_re " ") (re.+ (re.range "0" "9")) ((_ re.loop 2 2) (re.++ (str.to_re ":") (re.range "0" "5") (re.range "0" "9"))) (re.opt re.allchar) (re.* (re.range "0" "9")) (str.to_re "\u{0a}"))))
(check-sat)
