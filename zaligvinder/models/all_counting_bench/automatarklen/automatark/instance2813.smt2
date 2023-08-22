(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /STOR\u{20}PIC\u{5f}\d{6}[a-z]{2}\u{5f}\u{20}\u{5f}\d{7}\u{20}\u{2e}\d{3}/i
(assert (str.in_re X (re.++ (str.to_re "/STOR PIC_") ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_ _") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re " .") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/i\u{0a}"))))
; DmInf\x5E\x0D\x0A\x0D\x0AAttached\x2Fbar_pl\x2Fchk\.fcgi
(assert (str.in_re X (str.to_re "DmInf^\u{0d}\u{0a}\u{0d}\u{0a}Attached/bar_pl/chk.fcgi\u{0a}")))
; richfind\x2Ecomdcww\x2Edmcast\x2Ecom
(assert (not (str.in_re X (str.to_re "richfind.comdcww.dmcast.com\u{0a}"))))
; ^\d+(\.\d{2})?$
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re ".") ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; hotbar\s+ocllceclbhs\u{2f}gthftpquickbruteUser-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "hotbar") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "ocllceclbhs/gthftpquickbruteUser-Agent:\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
