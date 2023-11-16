dataviz_sansSR("De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_plot(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

dataviz_comp_sansSR(all_stat,"De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?",
             "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_plot_comp(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

new_dataviz_comp_sansSR(all_stat, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?",
             "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")
saving_newplot(graph, "De manière générale, avez-vous mis en place des clauses juridiques sur la gestion des données dans les contrats de délégation et dans les marchés publics ?")

dataviz_comp_sansSR(all_stat,"Quels sont le ou les domaines concernés par ces clauses ?",
             "Quels sont le ou les domaines concernés par ces clauses ?")
saving_plot_comp(graph, "Quels sont le ou les domaines concernés par ces clauses ?")

new_dataviz_comp_sansSR(all_stat, "Quels sont le ou les domaines concernés par ces clauses ?",
             "Quels sont le ou les domaines concernés par ces clauses ?")
saving_newplot(graph, "Quels sont le ou les domaines concernés par ces clauses ?")

dataviz_sansSR("La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_plot(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

dataviz_comp_sansSR(all_stat,"La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre collectivité a-t-elle défini une politique en matière de souveraineté publique sur les données ?",
             "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_plot_comp(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

new_dataviz_comp_sansSR(all_stat, "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre collectivité a-t-elle défini une politique en matière de souveraineté publique sur les données ?",
             "La question de la souveraineté numérique préoccupe de plus en plus d'acteurs publics : choix des éditeurs de logiciels, hébergement des données en Europe ou en France, maîtrise des données par la collectivité... Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")
saving_newplot(graph, "Votre organisation a-t-elle défini une politique en matière de souveraineté publique sur les données ?")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Energie et éclairage]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Energie et éclairage]")

dataviz_sansSR("Selon-vous, la maîtrise de la donnée constitue-t-elle un outil pertinent pour répondre aux enjeux environnementaux de votre territoire ?")
saving_plot(graph, "Selon-vous, la maîtrise de la donnée constitue-t-elle un outil pertinent pour répondre aux enjeux environnementaux de votre territoire ?")

dataviz_sansSR("Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_plot(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  dataviz_comp_sansSR("Comment estimez-vous le niveau d’acculturation de votre collectivité aux enjeux des données ?",
             "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_plot_comp(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

all_stat |> 
  mutate(Réponses = str_replace_all(Réponses, "collectivité", "structure")) |> 
  new_dataviz_comp_sansSR("Comment estimez-vous le niveau d’acculturation de votre collectivité aux enjeux des données ?",
             "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")
saving_newplot(graph, "Comment estimez-vous le niveau d’acculturation de votre structure aux enjeux des données ?")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Comité data]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Comité data]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Réseau de référent(e)s data]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Réseau de référent(e)s data]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Direction de la donnée]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Direction de la donnée]")

dataviz_sansSR("Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Chief data officer / administrateur général des données]")
saving_plot(graph, "Dans votre organisation, ces fonctions consacrées à la donnée existent-elles ou seront-elles créées dans les douze prochains mois ?  [Chief data officer - administrateur général des données]")

dataviz_sansSR("Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_plot(graph, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

all_stat |> 
  dataviz_comp_sansSR("Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre collectivité sont bien informés de cette obligation légale ?",
             "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_plot_comp(graph, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

new_dataviz_comp_sansSR(all_stat, "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre collectivité sont bien informés de cette obligation légale ?",
             "Depuis le 1er juillet 2020, les collectivités sont également soumises à une obligation de « transparence algorithmique ». Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")
saving_newplot(graph, "Pensez-vous que les services de votre structure sont bien informés de cette obligation légale ?")

dataviz_sansSR("Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_plot(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")

dataviz_comp_sansSR(all_stat,"Aujourd’hui, les données de votre collectivité sont majoritairement hébergées :",
             "Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_plot_comp(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")

new_dataviz_comp_sansSR(all_stat, "Aujourd’hui, les données de votre collectivité sont majoritairement hébergées :",
             "Aujourd’hui, les données de votre structure sont majoritairement hébergées :")
saving_newplot(graph, "Aujourd’hui, les données de votre structure sont majoritairement hébergées")


# 3.1

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Autre]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Autre]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Environnement]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Environnement]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Citoyenneté]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Citoyenneté]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Tourisme]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Tourisme]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Déchets]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Déchets]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Patrimoine]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Patrimoine]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Sécurité]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Sécurité]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Gestion de l’espace public]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Gestion de l’espace public]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Développement économique]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Développement économique]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Administration]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Administration]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Mobilité]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Mobilité]")

dataviz_sansSR("Pour chacun de ces domaines, pouvez-vous préciser si votre structure a engagé ces deux dernières années un ou plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Aménagement du territoire]")
saving_plot(graph, "Pouvez-vous préciser si votre structure a engagé plusieurs projets ou expérimentations en matière d'utilisation des données, ou prévoit d’en engager au cours des douze prochains mois ? [Aménagement du territoire]")













