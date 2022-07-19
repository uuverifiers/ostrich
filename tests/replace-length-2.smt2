(set-logic QF_S)

(declare-fun x_4 () String)
(declare-fun sigmaStar_0 () String)

(assert (= x_4 (str.replace sigmaStar_0 "\u{2f}\u{5b}\u{5e}\u{30}\u{2d}\u{39}\u{61}\u{2d}\u{7a}\u{5c}\u{2d}\u{5f}\u{2c}\u{5d}\u{2b}\u{2f}\u{69}" "")))

(assert (> (str.len sigmaStar_0) (str.len x_4)))

(check-sat)
