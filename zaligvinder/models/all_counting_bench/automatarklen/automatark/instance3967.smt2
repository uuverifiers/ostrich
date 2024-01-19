(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[-+]?\d*$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "-") (str.to_re "+"))) (re.* (re.range "0" "9")) (str.to_re "\u{0a}")))))
; (01*0|1)*
(assert (str.in_re X (re.++ (re.* (re.union (re.++ (str.to_re "0") (re.* (str.to_re "1")) (str.to_re "0")) (str.to_re "1"))) (str.to_re "\u{0a}"))))
; ^[^';<>?%!\s]{1,20}$
(assert (str.in_re X (re.++ ((_ re.loop 1 20) (re.union (str.to_re "'") (str.to_re ";") (str.to_re "<") (str.to_re ">") (str.to_re "?") (str.to_re "%") (str.to_re "!") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; \.cfg.*spyblini\x2Eini[^\n\r]*urfiqileuq\u{2f}tjzu.*Host\x3A666password\x3B1\x3BOptixGmbHPG=SPEEDBARcuReferer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".cfg") (re.* re.allchar) (str.to_re "spyblini.ini") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "urfiqileuq/tjzu") (re.* re.allchar) (str.to_re "Host:666password;1;OptixGmbHPG=SPEEDBARcuReferer:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
