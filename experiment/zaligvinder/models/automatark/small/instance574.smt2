(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([0-9a-f]{0,4}:){2,7}(:|[0-9a-f]{1,4})$
(assert (not (str.in_re X (re.++ ((_ re.loop 2 7) (re.++ ((_ re.loop 0 4) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re ":"))) (re.union (str.to_re ":") ((_ re.loop 1 4) (re.union (re.range "0" "9") (re.range "a" "f")))) (str.to_re "\u{0a}")))))
; dialupvpn\u{5f}pwd\w+tvlistings\s+fowclxccdxn\u{2f}uxwn\.ddywww\u{2e}virusprotectpro\u{2e}com\stoolbar\.anwb\.nl
(assert (str.in_re X (re.++ (str.to_re "dialupvpn_pwd") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "tvlistings") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "fowclxccdxn/uxwn.ddywww.virusprotectpro.com") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "toolbar.anwb.nl\u{0a}"))))
; (((^[>]?1.0)(\d)?(\d)?)|(^[<]?1.0(([1-9])|(\d[1-9])|([1-9]\d)))|(^[<]?1.4(0)?(0)?)|(^[<>]?1.(([123])(\d)?(\d)?)))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")) (re.opt (str.to_re ">")) (str.to_re "1") re.allchar (str.to_re "0")) (re.++ (re.opt (str.to_re "<")) (str.to_re "1") re.allchar (str.to_re "0") (re.union (re.range "1" "9") (re.++ (re.range "0" "9") (re.range "1" "9")) (re.++ (re.range "1" "9") (re.range "0" "9")))) (re.++ (re.opt (str.to_re "<")) (str.to_re "1") re.allchar (str.to_re "4") (re.opt (str.to_re "0")) (re.opt (str.to_re "0"))) (re.++ (re.opt (re.union (str.to_re "<") (str.to_re ">"))) (str.to_re "1") re.allchar (re.union (str.to_re "1") (str.to_re "2") (str.to_re "3")) (re.opt (re.range "0" "9")) (re.opt (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Everyware.*Email.*Host\x3Astepwww\x2Ekornputers\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Everyware") (re.* re.allchar) (str.to_re "Email") (re.* re.allchar) (str.to_re "Host:stepwww.kornputers.com\u{0a}"))))
; ([0-9]+:)?[0-9]+\s*(am|pm)|[0-9]+:[0-9]+\s*(am|pm)?
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re ":"))) (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "am") (str.to_re "pm"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re ":") (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "am") (str.to_re "pm"))) (str.to_re "\u{0a}")))))
(check-sat)
