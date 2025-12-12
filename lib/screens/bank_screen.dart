import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final gameState = gameProvider.gameState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank - Droid Gangwar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => gameProvider.navigateToScreen('city'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.deepPurple.shade600,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '🏦 BANK',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Money: \$${gameState.money}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        'Bank Account: \$${gameState.account}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Manage your finances, take loans, and grow your empire.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildBankActionCard(
                      context,
                      'Deposit Money',
                      'Deposit cash into your bank account for safe keeping',
                      Colors.green,
                      () => _showDepositDialog(context),
                    ),
                    const SizedBox(height: 10),
                    _buildBankActionCard(
                      context,
                      'Withdraw Money',
                      'Withdraw cash from your bank account',
                      Colors.blue,
                      () => _showWithdrawDialog(context),
                    ),
                    const SizedBox(height: 10),
                    _buildBankActionCard(
                      context,
                      'Take Loan',
                      'Borrow money to expand your operations (with interest)',
                      Colors.orange,
                      () => _showLoanDialog(context),
                    ),
                    const SizedBox(height: 10),
                    _buildBankActionCard(
                      context,
                      'Repay Loan',
                      'Repay your outstanding loan to avoid trouble',
                      Colors.red,
                      gameState.loan > 0 ? () => _showRepayDialog(context) : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GameButton(
                text: 'Return to City',
                onPressed: () => gameProvider.navigateToScreen('city'),
                icon: Icons.arrow_back,
                backgroundColor: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBankActionCard(BuildContext context, String title, String description, Color color, VoidCallback? onPressed) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deposit Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available cash: \$${gameProvider.gameState.money}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to deposit',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.money) {
                gameProvider.gameState.money -= amount;
                gameProvider.gameState.account += amount;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Deposited \$${amount.toString()}')),
                );
              }
            },
            child: const Text('Deposit'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Bank account: \$${gameProvider.gameState.account}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to withdraw',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.account) {
                gameProvider.gameState.money += amount;
                gameProvider.gameState.account -= amount;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Withdrew \$${amount.toString()}')),
                );
              }
            },
            child: const Text('Withdraw'),
          ),
        ],
      ),
    );
  }

  void _showLoanDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController(text: '1000');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Take Loan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Warning: Loans have high interest!'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Loan amount',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                gameProvider.gameState.money += amount;
                gameProvider.gameState.loan += amount;
                gameProvider.gameState.flags.hasAttractedLoanShark = true;
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Took loan of \$${amount.toString()} - be careful!')),
                );
              }
            },
            child: const Text('Take Loan'),
          ),
        ],
      ),
    );
  }

  void _showRepayDialog(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Repay Loan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current loan: \$${gameProvider.gameState.loan}'),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount to repay',
                hintText: 'Enter amount',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final amount = int.tryParse(amountController.text) ?? 0;
              if (amount > 0 && amount <= gameProvider.gameState.money) {
                gameProvider.gameState.money -= amount;
                gameProvider.gameState.loan -= amount;
                if (gameProvider.gameState.loan <= 0) {
                  gameProvider.gameState.flags.hasAttractedLoanShark = false;
                }
                gameProvider.saveGameState();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Repaid \$${amount.toString()} on your loan')),
                );
              }
            },
            child: const Text('Repay'),
          ),
        ],
      ),
    );
  }
}
