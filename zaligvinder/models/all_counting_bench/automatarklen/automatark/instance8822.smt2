(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /STOR\u{20}PIC\u{5f}\d{6}[a-z]{2}\u{5f}\u{20}\u{5f}\d{7}\u{20}\u{2e}\d{3}/i
(assert (not (str.in_re X (re.++ (str.to_re "/STOR PIC_") ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "a" "z")) (str.to_re "_ _") ((_ re.loop 7 7) (re.range "0" "9")) (str.to_re " .") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "/i\u{0a}")))))
; OS-www\x2Etopadwarereviews\x2Ecommedia\x2Etop-banners\x2EcomSuccessfully\u{21}
(assert (not (str.in_re X (str.to_re "OS-www.topadwarereviews.commedia.top-banners.comSuccessfully!\u{0a}"))))
; /^\/index\.php\?[A-Za-z0-9_-]{15}=l3S/U
(assert (str.in_re X (re.++ (str.to_re "//index.php?") ((_ re.loop 15 15) (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re "-"))) (str.to_re "=l3S/U\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
