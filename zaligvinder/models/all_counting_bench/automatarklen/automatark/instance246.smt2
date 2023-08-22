(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9,]+['][-](\d|1[01])"$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re ","))) (str.to_re "'-") (re.union (re.range "0" "9") (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "1")))) (str.to_re "\u{22}\u{0a}"))))
; \.cfg\d+stale\d+GmbHPG=SPEEDBARcuReferer\x3ASpediazmnjgmomgbdz\u{2f}zzmw\.gztHost\x3AHost\x3Azopabora\x2Einfo
(assert (not (str.in_re X (re.++ (str.to_re ".cfg") (re.+ (re.range "0" "9")) (str.to_re "stale") (re.+ (re.range "0" "9")) (str.to_re "GmbHPG=SPEEDBARcuReferer:Spediazmnjgmomgbdz/zzmw.gztHost:Host:zopabora.info\u{0a}")))))
; \d{2}.?\d{3}.?\d{3}/?\d{4}-?\d{2}
(assert (str.in_re X (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re "/")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; Agent\s+\x2Ftoolbar\x2Fico\x2F
(assert (str.in_re X (re.++ (str.to_re "Agent") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/toolbar/ico/\u{0a}"))))
; ^(.|\r|\n){1,10}$
(assert (str.in_re X (re.++ ((_ re.loop 1 10) (re.union re.allchar (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
