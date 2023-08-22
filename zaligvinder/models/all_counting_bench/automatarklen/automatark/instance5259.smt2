(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (^\([0]\d{1}\))(\d{7}$)|(^\([0][2]\d{1}\))(\d{6,8}$)|([0][8][0][0])([\s])(\d{5,8}$)
(assert (str.in_re X (re.union (re.++ ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re "(0") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ ((_ re.loop 6 8) (re.range "0" "9")) (str.to_re "(02") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")")) (re.++ (str.to_re "0800") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 5 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \x2Fezsb\s+hirmvtg\u{2f}ggqh\.kqh\dRemotetoolsbar\x2Ekuaiso\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "/ezsb") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "hirmvtg/ggqh.kqh\u{1b}") (re.range "0" "9") (str.to_re "Remotetoolsbar.kuaiso.com\u{0a}"))))
; /filename=[^\n]*\u{2e}lnk/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".lnk/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
